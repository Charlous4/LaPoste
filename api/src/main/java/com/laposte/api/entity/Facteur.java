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
@Table(name = "facteur")
public class Facteur {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String nom;
    private String prenom;
    private String contrat;
    private String role;

    // ------------------------------------------------------------------
    // LA SOLUTION EST ICI :
    // On lie le facteur à ses affectations.
    // cascade = CascadeType.REMOVE -> Supprime l'historique des affectations 
    // de ce facteur s'il est supprimé de la base de données.
    // ------------------------------------------------------------------
    @JsonIgnore 
    @OneToMany(mappedBy = "facteur", cascade = CascadeType.REMOVE)
    private List<Affectation> affectations;

    // Getters et Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getContrat() { return contrat; }
    public void setContrat(String contrat) { this.contrat = contrat; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public List<Affectation> getAffectations() { return affectations; }
    public void setAffectations(List<Affectation> affectations) { this.affectations = affectations; }
}