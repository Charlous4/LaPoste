package com.laposte.api.repository;

import com.laposte.api.entity.Tournee;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TourneeRepository extends JpaRepository<Tournee, Integer> {
}