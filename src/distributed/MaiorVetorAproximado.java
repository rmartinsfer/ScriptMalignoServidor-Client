package distributed;

public class MaiorVetorAproximado {
   public static void main(String[] args) {
       System.out.println("Estimando o maior tamanho possível de vetor em Java...");
       long inicio = System.currentTimeMillis();

       int tamanho = 1_000_000;
       int ultimoBemSucedido = 0;

       while (true) {
           try {
               byte[] vetor = new byte[tamanho];
               ultimoBemSucedido = tamanho;
               vetor = null;
               System.gc();

               if (tamanho > Integer.MAX_VALUE / 3 * 2) break;

               tamanho = (tamanho / 2) * 3;

               System.out.printf("Alocado com sucesso: %,d elementos%n", ultimoBemSucedido);
           } catch (OutOfMemoryError e) {
              System.out.printf("Falhou em %,d elementos%n", tamanho);
              break;
           }
       }

       long fim = System.currentTimeMillis();
       System.out.println("\nMaior vetor que coube (aproximadamente): "+ String.format("%,d", ultimoBemSucedido));
       System.out.printf("Memória estimada: %.2f MB%n", ultimoBemSucedido * 1.0 / (1024 * 1024));
       System.out.printf("Tempo total: %.2f segundos%n", (fim - inicio) / 1000.0);
   }
}