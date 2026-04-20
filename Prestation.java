import java.util.ArrayList;

public class Prestation {
    String type;
    String adresse;
    Tournee uneTournee;
    private static ArrayList<Prestation> toutesLesPrestations = new ArrayList<>();

    public Prestation(String type, String adresse, Tournee uneTournee){
        this.type = type;
        this.adresse = adresse;
        this.uneTournee = uneTournee;
        if (uneTournee != null) {
            uneTournee.getListePrestations().add(this); 
        }
        toutesLesPrestations.add(this);
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public Tournee getUneTournee() {
        return uneTournee;
    }

    public void setUneTournee(Tournee uneTournee) {
        this.uneTournee = uneTournee;
    }

    public static ArrayList<Prestation> getToutesLesPrestations() {
        return toutesLesPrestations;
    }

    @Override
    public String toString(){
        return type + " sur la tournee " + uneTournee.getNumero() + " a l'adresse " + adresse;
    }
    public void ajouterATournee(Tournee t){
        this.uneTournee = t;
        t.getListePrestations().add(this);
    }

}
