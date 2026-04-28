package com.laposte.api.entity;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "affectation")
public class Affectation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "id_facteur")
    private Facteur facteur;

    @ManyToOne
    @JoinColumn(name = "id_tournee")
    private Tournee tournee;

    private LocalDate dateDebut;
    private LocalDate dateFin;
    private String roleAffectation;

    // Getters et Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Facteur getFacteur() { return facteur; }
    public void setFacteur(Facteur facteur) { this.facteur = facteur; }

    public Tournee getTournee() { return tournee; }
    public void setTournee(Tournee tournee) { this.tournee = tournee; }

    public LocalDate getDateDebut() { return dateDebut; }
    public void setDateDebut(LocalDate dateDebut) { this.dateDebut = dateDebut; }

    public LocalDate getDateFin() { return dateFin; }
    public void setDateFin(LocalDate dateFin) { this.dateFin = dateFin; }

    public String getRoleAffectation() { return roleAffectation; }
    public void setRoleAffectation(String roleAffectation) { this.roleAffectation = roleAffectation; }
}