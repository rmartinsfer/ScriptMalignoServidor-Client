package distributed;

import java.io.Serializable;
import java.util.concurrent.*;
import java.util.concurrent.atomic.LongAdder;

public class Pedido extends Comunicado implements Serializable {
    private static final long serialVersionUID = 2L;

    private final int[] numeros;
    private final int procurado;

    public Pedido(int[] numeros, int procurado) {
        this.numeros = numeros;
        this.procurado = procurado;
    }

    public int getProcurado() { return procurado; }
    public int[] getNumeros() { return numeros; }

    /**
     * Conta ocorrências de forma paralela, respeitando o número de processadores disponíveis.
     */
    public int contar() {
        final int n = numeros.length;
        if (n == 0) return 0;

        final int cores = Math.max(1, Runtime.getRuntime().availableProcessors());
        final int tarefas = Math.min(cores, n);
        final LongAdder soma = new LongAdder();

        ExecutorService pool = Executors.newFixedThreadPool(tarefas);
        int bloco = (n + tarefas - 1) / tarefas; // ceiling

        for (int t = 0; t < tarefas; t++) {
            final int inicio = t * bloco;
            final int fim = Math.min(n, inicio + bloco);
            if (inicio >= fim) break;
            pool.execute(() -> {
                int c = 0;
                for (int i = inicio; i < fim; i++) {
                    if (numeros[i] == procurado) c++;
                }
                soma.add(c);
            });
        }

        pool.shutdown();
        try {
            pool.awaitTermination(365, TimeUnit.DAYS);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        return soma.intValue();
    }
}