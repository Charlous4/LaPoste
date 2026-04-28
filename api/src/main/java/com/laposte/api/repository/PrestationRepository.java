package com.laposte.api.repository;

import com.laposte.api.entity.Prestation;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PrestationRepository extends JpaRepository<Prestation, Integer> {
}