package distributed;
import java.io.Serializable;

public class Resposta extends Comunicado implements Serializable {
    private static final long serialVersionUID = 3L;
    private final Integer contagem; // usar Integer para poder ser null

    public Resposta(int contagem) { 
        this.contagem = contagem; 
    }
    public Integer getContagem() { 
        return contagem; 
    }
}