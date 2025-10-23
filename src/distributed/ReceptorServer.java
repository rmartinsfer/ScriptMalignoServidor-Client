package distributed;

import java.io.*;
import java.net.*;

public class ReceptorServer {
    // Uso: java distributed.ReceptorServer [host=0.0.0.0] [porta=12345]
    public static void main(String[] args) {
        String hostBind = args.length > 0 ? args[0] : "0.0.0.0";
        int porta = args.length > 1 ? Integer.parseInt(args[1]) : 12345;

        try (ServerSocket servidor = new ServerSocket()) {
            servidor.bind(new InetSocketAddress(hostBind, porta));
            Log.info("R", "Servidor R ouvindo em " + hostBind + ":" + porta);

            while (true) {
                Socket conexao = servidor.accept();
                Log.info("R", "Conexão aceita de " + conexao.getRemoteSocketAddress());
                new Thread(new Atendedor(conexao)).start();
            }
        } catch (IOException e) {
            Log.error("R", "Falha ao iniciar servidor", e);
        }
    }

    private static class Atendedor implements Runnable {
        private final Socket socket;
        Atendedor(Socket s) { this.socket = s; }

        @Override public void run() {
            try (
                ObjectOutputStream transmissor = new ObjectOutputStream(socket.getOutputStream());
                ObjectInputStream  receptor    = new ObjectInputStream(socket.getInputStream())
            ) {
                while (true) {
                    Object obj = receptor.readObject();
                    if (obj instanceof Pedido) {
                        Pedido p = (Pedido) obj;
                        Log.info("R", "Pedido recebido de " + socket.getRemoteSocketAddress() +
                                " — procurando: " + p.getProcurado() + ", tamanho: " + p.getNumeros().length);
                        int cont = p.contar();
                        transmissor.writeObject(new Resposta(cont));
                        transmissor.flush();
                    } else if (obj instanceof ComunicadoEncerramento) {
                        Log.warn("R", "Encerramento recebido de " + socket.getRemoteSocketAddress());
                        break; // encerra a conexão e volta a aceitar outra
                    } else if (obj instanceof Comunicado) {
                        Log.warn("R", "Comunicado desconhecido: " + obj.getClass().getSimpleName());
                    } else {
                        Log.warn("R", "Objeto não suportado: " + obj.getClass());
                    }
                }
            } catch (EOFException e) {
                Log.warn("R", "Cliente fechou a conexão: " + socket.getRemoteSocketAddress());
            } catch (IOException | ClassNotFoundException e) {
                Log.error("R", "Erro na conexão com cliente", e);
            } finally {
                try { socket.close(); } catch (IOException ignore) {}
                Log.info("R", "Conexão encerrada: " + socket.getRemoteSocketAddress());
            }
        }
    }
}