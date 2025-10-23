package distributed;

import java.io.*;
import java.net.*;
import java.util.*;

public class Distribuidor {
    /**
     * Uso:
     *   java distributed.Distribuidor host1:porta host2:porta ... [--tam N] [--missing]
     * Exemplo local (3 R em portas diferentes):
     *   java distributed.Distribuidor localhost:12345 localhost:12346 localhost:12347 --tam 30000000 --missing
     */
    public static void main(String[] args) throws Exception {
        if (args.length == 0) {
            System.out.println("Forneça ao menos um R no formato host:porta. Opções: --tam N, --missing");
            return;
        }

        // Parse de argumentos
        List<String> destinos = new ArrayList<>();
        int tamanho = 10_000_000; // padrão
        boolean missing = false;

        for (int i = 0; i < args.length; i++) {
            String a = args[i];
            if (a.equals("--tam")) {
                tamanho = Integer.parseInt(args[++i]);
            } else if (a.equals("--missing")) {
                missing = true;
            } else if (a.contains(":")) {
                destinos.add(a);
            }
        }
        if (destinos.isEmpty()) {
            System.out.println("Nenhum destino R informado.");
            return;
        }

        // Gera vetor e escolhe número procurado
        final Random rnd = new Random();
        int[] vetor = new int[tamanho];
        for (int i = 0; i < tamanho; i++) vetor[i] = rnd.nextInt(201) - 100; // [-100,100]
        int pos = rnd.nextInt(tamanho);
        int procurado = vetor[pos];

        Log.info("D", "Vetor gerado: " + tamanho + " elementos; alvo escolhido (pos=" + pos + ") = " + procurado);

        // Prepara conexões persistentes (uma por servidor)
        List<Connection> conns = new ArrayList<>();
        for (String alvo : destinos) {
            String[] hp = alvo.split(":");
            conns.add(new Connection(hp[0], Integer.parseInt(hp[1])));
        }
        for (Connection c : conns) c.connect();

        // Rodada 1: número existente
        executarRodada("EXISTENTE", conns, vetor, procurado);

        // Rodada 2 (opcional): número inexistente 111
        if (missing) executarRodada("INEXISTENTE", conns, vetor, 111);

        // Envia encerramento e fecha
        for (Connection c : conns) {
            try { c.sendEncerramento(); } catch (Exception e) { Log.error("D", "Falha ao encerrar " + c, e); }
            c.close();
        }
        Log.info("D", "Encerramento enviado para todos os R e conexões fechadas.");
    }

    private static void executarRodada(String rotulo, List<Connection> conns, int[] vetor, int procurado) throws Exception {
        Log.info("D", "— Rodada " + rotulo + " — alvo=" + procurado);

        int partes = conns.size();
        int bloco = (vetor.length + partes - 1) / partes; // ceiling

        final int[] parciais = new int[partes];
        Thread[] threads = new Thread[partes];

        long ini = System.nanoTime();

        for (int idx = 0; idx < partes; idx++) {
            final int i = idx;
            final int inicio = i * bloco;
            final int fim = Math.min(vetor.length, inicio + bloco);
            final int[] subvetor = Arrays.copyOfRange(vetor, inicio, fim);
            final Connection conn = conns.get(i);

            threads[i] = new Thread(() -> {
                try {
                    Resposta r = conn.sendPedido(new Pedido(subvetor, procurado));
                    parciais[i] = (r != null && r.getContagem() != null) ? r.getContagem() : 0;
                    Log.info("D", "Resposta de " + conn + ": parcial=" + parciais[i]);
                } catch (Exception e) {
                    Log.error("D", "Falha ao enviar pedido para " + conn, e);
                }
            });
            threads[i].start();
        }

        // Sincronização usando Thread.join() conforme especificado
        for (Thread t : threads) {
            try { t.join(); } catch (InterruptedException e) { Thread.currentThread().interrupt(); }
        }
        long fim = System.nanoTime();

        int total = 0; for (int v : parciais) total += v;
        double ms = (fim - ini) / 1_000_000.0;

        Log.info("D", String.format("TOTAL (%s): %d ocorrências. Tempo distribuído: %.2f ms", rotulo, total, ms));

        // Comparação sequencial local para a mesma rodada
        long iniSeq = System.nanoTime();
        int totalSeq = 0; for (int x : vetor) if (x == procurado) totalSeq++;
        long fimSeq = System.nanoTime();
        double msSeq = (fimSeq - iniSeq) / 1_000_000.0;
        Log.info("D", String.format("Tempo sequencial local: %.2f ms (resultado=%d)", msSeq, totalSeq));
    }

    // Conexão persistente com um servidor R
    private static class Connection {
        private final String host;
        private final int porta;
        private Socket s;
        private ObjectOutputStream out;
        private ObjectInputStream in;

        Connection(String host, int porta) { this.host = host; this.porta = porta; }

        void connect() throws IOException {
            s = new Socket();
            s.connect(new InetSocketAddress(host, porta), 30_000);
            s.setTcpNoDelay(true);
            out = new ObjectOutputStream(s.getOutputStream());
            in  = new ObjectInputStream(s.getInputStream());
            Log.info("D", "Conectado a " + this);
        }

        Resposta sendPedido(Pedido p) throws IOException, ClassNotFoundException {
            synchronized (this) { // garante ordem pedido-resposta por conexão
                out.writeObject(p);
                out.flush();
                Object resp = in.readObject();
                if (resp instanceof Resposta) {
                    return (Resposta) resp;
                } else {
                    Log.warn("D", "Objeto inesperado de " + this + ": " + resp.getClass().getSimpleName());
                    return null;
                }
            }
        }

        void sendEncerramento() throws IOException {
            synchronized (this) {
                out.writeObject(new ComunicadoEncerramento());
                out.flush();
            }
        }

        void close() {
            try { if (in != null) in.close(); } catch (IOException ignore) {}
            try { if (out != null) out.close(); } catch (IOException ignore) {}
            try { if (s != null) s.close(); } catch (IOException ignore) {}
            Log.info("D", "Conexão fechada: " + this);
        }

        @Override public String toString() { return host + ":" + porta; }
    }
}