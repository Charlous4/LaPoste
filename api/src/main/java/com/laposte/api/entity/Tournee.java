package com.laposte.api.entity;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.PreRemove; // <-- LE NOUVEL IMPORT EST ICI
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

    // 1. GESTION DES AFFECTATIONS (On supprime l'historique si on supprime la tournée)
    @JsonIgnore 
    @OneToMany(mappedBy = "tournee", cascade = CascadeType.REMOVE)
    private List<Affectation> affectations;
    
    // 2. GESTION DES PRESTATIONS (On les détache pour ne pas perdre les demandes clients)
    @JsonIgnore
    @OneToMany(mappedBy = "tournee")
    private List<Prestation> prestations;

    @PreRemove
    private void preRemove() {
        // Cette fonction s'exécute toute seule juste avant que la tournée soit supprimée de la base
        if (prestations != null) {
            for (Prestation p : prestations) {
                p.setTournee(null); // On remet la prestation à "Aucune tournée"
            }
        }
    }

    // --- Getters et Setters ---
    
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

    public List<Prestation> getPrestations() { return prestations; }
    public void setPrestations(List<Prestation> prestations) { this.prestations = prestations; }
}