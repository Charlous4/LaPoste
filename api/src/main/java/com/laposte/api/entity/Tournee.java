package com.laposte.api.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "tournee")
public class Tournee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private Integer numero;
    private String vehicule;
    private String rues;

    // Getters et Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getNumero() { return numero; }
    public void setNumero(Integer numero) { this.numero = numero; }

    public String getVehicule() { return vehicule; }
    public void setVehicule(String vehicule) { this.vehicule = vehicule; }

    public String getRues() { return rues; }
    public void setRues(String rues) { this.rues = rues; }
}