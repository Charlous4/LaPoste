package com.laposte.api.repository;

import com.laposte.api.entity.Facteur;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FacteurRepository extends JpaRepository<Facteur, Integer> {
}