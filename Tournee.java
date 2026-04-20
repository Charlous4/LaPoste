
import java.util.ArrayList;
import java.util.Arrays;

public class Tournee {
    public int numero;
    private ArrayList<String> rues;
    public Moloc vehicule;
    public ArrayList<Prestation> listePrestations = new ArrayList<>();
    public Tournee(int numero, Moloc vehicule,String... nomsDesRues) {
        this.numero = numero;
        this.vehicule = vehicule;
        this.rues = new ArrayList<>(Arrays.asList(nomsDesRues));
    }

    public int getNumero() {
        return numero;
    }

    public void ajouterRue(String nomRue){
        this.rues.add(nomRue);
    }

    public ArrayList<String> getRues() {
        return rues;
    }

    public void setRues(ArrayList<String> rues) {
        this.rues = rues;
    }

    public void supprimerRue(String nomRue){
        this.rues.remove(nomRue);
    }

    public Moloc getVehicule() {
        return vehicule;
    }

    public void setVehicule(Moloc vehicule) {
        this.vehicule = vehicule;
    }

    public ArrayList<Prestation> getListePrestations() {
        return listePrestations;
    }

}
