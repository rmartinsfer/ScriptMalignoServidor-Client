package distributed;

import java.util.Random;

public class ContagemSequencial {
    public static void main(String[] args) {
        int tamanho = 10_000_000;
        boolean missing = false;
        for (int i = 0; i < args.length; i++) {
            if ("--missing".equals(args[i])) missing = true;
            else tamanho = Integer.parseInt(args[i]);
        }

        Random rnd = new Random();
        int[] v = new int[tamanho];
        for (int i = 0; i < tamanho; i++) v[i] = rnd.nextInt(201) - 100;
        int pos = rnd.nextInt(tamanho);
        int procurado = v[pos];

        Log.info("SEQ", "Rodada EXISTENTE — procurando " + procurado);
        medir(v, procurado);

        if (missing) {
            Log.info("SEQ", "Rodada INEXISTENTE — procurando 111");
            medir(v, 111);
        }
    }

    private static void medir(int[] v, int alvo) {
        long ini = System.nanoTime();
        int c = 0; for (int x : v) if (x == alvo) c++;
        long fim = System.nanoTime();
        Log.info("SEQ", String.format("Resultado=%d, Tempo=%.2f ms", c, (fim-ini)/1_000_000.0));
    }
}