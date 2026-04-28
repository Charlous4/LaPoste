package com.laposte.api.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "prestation")
public class Prestation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String type;
    private String adresse;

    @ManyToOne
    @JoinColumn(name = "id_tournee")
    private Tournee tournee;

    // Getters et Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }

    public Tournee getTournee() { return tournee; }
    public void setTournee(Tournee tournee) { this.tournee = tournee; }
}