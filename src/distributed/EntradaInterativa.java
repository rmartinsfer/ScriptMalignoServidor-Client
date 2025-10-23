package distributed;

import java.io.*;
import java.net.*;
import java.util.*;

public class EntradaInterativa {
    public static void main(String[] args) throws Exception {
        System.out.println("🌐 TESTE INTERATIVO - SISTEMA DISTRIBUÍDO");
        System.out.println("========================================");
        System.out.println();
        
        Scanner scanner = new Scanner(System.in);
        List<String> destinos = new ArrayList<>();
        
        System.out.println("ℹ️  Digite os IPs no formato: IP:PORTA");
        System.out.println("ℹ️  Exemplo: 192.168.1.100:12345");
        System.out.println("ℹ️  Pressione ENTER sem digitar nada para finalizar");
        System.out.println();
        
        int contador = 1;
        while (true) {
            System.out.print("IP " + contador + " (formato IPv4:porta): ");
            String entrada = scanner.nextLine().trim();
            
            if (entrada.isEmpty()) {
                break;
            }
            
            if (entrada.contains(":")) {
                String[] partes = entrada.split(":");
                if (partes.length == 2) {
                    String ip = partes[0];
                    String porta = partes[1];
                    
                    if (validarIPv4(ip)) {
                        try {
                            int port = Integer.parseInt(porta);
                            if (port >= 1 && port <= 65535) {
                                destinos.add(entrada);
                                System.out.println("✅ IP " + contador + " adicionado: " + entrada);
                                contador++;
                            } else {
                                System.out.println("❌ Porta inválida: " + porta + " (deve ser 1-65535)");
                            }
                        } catch (NumberFormatException e) {
                            System.out.println("❌ Porta inválida: " + porta);
                        }
                    } else {
                        System.out.println("❌ IPv4 inválido: " + ip);
                        System.out.println("ℹ️  Formato correto: 192.168.1.100");
                    }
                } else {
                    System.out.println("❌ Formato inválido. Use: IP:PORTA");
                    System.out.println("ℹ️  Exemplo: 192.168.1.100:12345");
                }
            } else {
                System.out.println("❌ Formato inválido. Use: IP:PORTA");
                System.out.println("ℹ️  Exemplo: 192.168.1.100:12345");
            }
        }
        
        if (destinos.isEmpty()) {
            System.out.println("❌ Nenhum IP fornecido!");
            return;
        }
        
        System.out.println("✅ Total de IPs: " + destinos.size());
        System.out.println("ℹ️  IPs coletados: " + String.join(" ", destinos));
        System.out.println();
        
        System.out.println("ℹ️  Iniciando teste distribuído...");
        System.out.println("ℹ️  IPs fornecidos: " + String.join(" ", destinos));
        System.out.println();
        
        String[] argsArray = destinos.toArray(new String[0]);
        String[] argsCompletos = new String[argsArray.length + 2];
        System.arraycopy(argsArray, 0, argsCompletos, 0, argsArray.length);
        argsCompletos[argsArray.length] = "--tam";
        argsCompletos[argsArray.length + 1] = "10000";
        
        Distribuidor.main(argsCompletos);
        
        scanner.close();
    }
    
    private static boolean validarIPv4(String ip) {
        if (ip == null || ip.isEmpty()) {
            return false;
        }
        
        String[] partes = ip.split("\\.");
        if (partes.length != 4) {
            return false;
        }
        
        try {
            for (String parte : partes) {
                int octeto = Integer.parseInt(parte);
                if (octeto < 0 || octeto > 255) {
                    return false;
                }
            }
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
