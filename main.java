
public class main {
 public static void main(String[] args) {
    Tournee t101 = new Tournee(3101,Moloc.VAE,"Rue Alfred Herault", "Rue du General Reibel", "Rue du General Sarrail");
    Tournee t107 = new Tournee(3107,Moloc.VAE,"Rue Jeanne d'Arc", "Rue de la Chevretterie", "Bd Victor Hugo", "Faubourg St Jacques", "Rue Hilaire Gilbert"); 
    Tournee t113 = new Tournee(9113, Moloc.VCAE,"Rue Bourbon","Rue des limousins","Av Pierre Ablin");
    Tournee t411 = new Tournee(9411,Moloc.VOITURE,"Rue Francois Arago", "Rue Gustave Eiffeil","Rue de la Bastille");
    Prestation p1 = new Prestation("ExpBal", "128 Rue Bourbon", t113);
    Prestation p2 = new Prestation("Collecte", "55 rue du 14e RTA", t107);
    Prestation p3 = new Prestation("BAL Jaune", "67 rue des Naurais", t107);
    Prestation p4 = new Prestation("BAL Jaune", "1 rue Beauregard", null);
    Facteur facteur1 = new Facteur("PLANCHET","Mickael",Contrat.CDI,Role.TITULAIRE,t107);
    Facteur facteur2 = new Facteur("RUBIO","Charles",Contrat.INTERIM,Role.REMPLACANT,null);
    p4.ajouterATournee(t101);
    System.out.println(facteur2.toString());
    //System.out.println(t101.getListePrestations());
    //System.out.println(Prestation.getToutesLesPrestations());
 }

}
