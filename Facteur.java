public class Facteur{
    String nom;
    String prenom;
    Contrat unContrat;
    Tournee uneTournee;
    Role unRole;
    public Facteur(String nom, String prenom, Contrat unContrat, Role unRole, Tournee uneTournee){
        this.nom = nom;
        this.prenom = prenom;
        this.unContrat = unContrat;
        this.unRole = unRole;
        if (unRole == Role.REMPLACANT || unRole == Role.ROULEUR) {
            this.uneTournee = null;
        } else{
            this.uneTournee = uneTournee;
        }
    }
    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public Contrat getUnContrat() {
        return unContrat;
    }

    public void setUnContrat(Contrat unContrat) {
        this.unContrat = unContrat;
    }

    public Tournee getUneTournee() {
        return uneTournee;
    }

    public void setUneTournee(Tournee uneTournee) {
        this.uneTournee = uneTournee;
    }

    public Role getUnRole() {
        return unRole;
    }

    public void setUnRole(Role unRole) {
        this.unRole = unRole;
    }

    @Override
    public String toString(){
        if(uneTournee == null ){
            return " Facteur " + prenom + " " + nom + ", il n'a pas de tournee";
        }else
        
            {
            return " Facteur " + prenom + " " + nom + ", tournee " + uneTournee.getNumero() + ", vehicule : " + uneTournee.vehicule + ", secteur : " + uneTournee.getRues();
            }
    }


    
}