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

    public int contar() {
        final int n = numeros.length;
        if (n == 0) return 0; // edge case

        // usar todos os cores disponíveis
        final int cores = Math.max(1, Runtime.getRuntime().availableProcessors());
        final int tarefas = Math.min(cores, n); // não mais tarefas que elementos
        final LongAdder soma = new LongAdder(); // thread-safe

        ExecutorService pool = Executors.newFixedThreadPool(tarefas);
        int bloco = (n + tarefas - 1) / tarefas; // dividir igualmente

        for (int t = 0; t < tarefas; t++) {
            final int inicio = t * bloco;
            final int fim = Math.min(n, inicio + bloco);
            if (inicio >= fim) break; // evitar tarefas vazias
            pool.execute(() -> {
                int c = 0;
                for (int i = inicio; i < fim; i++) {
                    if (numeros[i] == procurado) c++; // contagem local
                }
                soma.add(c); // somar ao total
            });
        }

        pool.shutdown();
        try {
            pool.awaitTermination(365, TimeUnit.DAYS); // esperar indefinidamente
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        return soma.intValue();
    }
}
