package com.laposte.api.repository;

import com.laposte.api.entity.Affectation;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AffectationRepository extends JpaRepository<Affectation, Integer> {
}