package distributed;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public final class Log {
    private static final DateTimeFormatter F = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private Log() {} // classe utilitária

    public static void info(String tag, String msg) {
        System.out.printf("[%s] %s — %s%n", tag, LocalDateTime.now().format(F), msg);
    }
    public static void warn(String tag, String msg) {
        System.out.printf("[%s][WARN] %s — %s%n", tag, LocalDateTime.now().format(F), msg);
    }
    public static void error(String tag, String msg, Throwable t) {
        System.out.printf("[%s][ERRO] %s — %s%n", tag, LocalDateTime.now().format(F), msg);
        if (t != null) t.printStackTrace(System.out); // stack trace completo
    }
}