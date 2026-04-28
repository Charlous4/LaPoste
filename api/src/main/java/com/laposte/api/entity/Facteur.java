package com.laposte.api.entity;

import jakarta.persistence.*;

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

    @ManyToOne
    @JoinColumn(name = "id_tournee")
    private Tournee tournee;

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

    public Tournee getTournee() { return tournee; }
    public void setTournee(Tournee tournee) { this.tournee = tournee; }
}