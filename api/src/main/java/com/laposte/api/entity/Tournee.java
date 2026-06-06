package com.laposte.api.entity;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;


@Entity
@Table(name = "tournee")
public class Tournee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private Integer numero;
    private String vehicule;
    private String rues;

    // ------------------------------------------------------------------
    // LA SOLUTION EST ICI :
    // On indique à la Tournee qu'elle est liée à plusieurs Affectations.
    // cascade = CascadeType.REMOVE -> Supprime l'historique des affectations 
    // liées si la tournée est supprimée.
    // ------------------------------------------------------------------
    @JsonIgnore 
    @OneToMany(mappedBy = "tournee", cascade = CascadeType.REMOVE)
    private List<Affectation> affectations;
    
    // (Optionnel) Si tu as le même problème avec les Prestations, ajoute ceci :
    // @JsonIgnore
    // @OneToMany(mappedBy = "tournee")
    // private List<Prestation> prestations;
    //
    // @PreRemove
    // private void preRemove() {
    //     // Détache les prestations avant de supprimer la tournée pour ne pas perdre les requêtes client
    //     if (prestations != null) {
    //         for (Prestation p : prestations) {
    //             p.setTournee(null);
    //         }
    //     }
    // }
    // ------------------------------------------------------------------

    // Getters et Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getNumero() { return numero; }
    public void setNumero(Integer numero) { this.numero = numero; }

    public String getVehicule() { return vehicule; }
    public void setVehicule(String vehicule) { this.vehicule = vehicule; }

    public String getRues() { return rues; }
    public void setRues(String rues) { this.rues = rues; }

    public List<Affectation> getAffectations() { return affectations; }
    public void setAffectations(List<Affectation> affectations) { this.affectations = affectations; }
}