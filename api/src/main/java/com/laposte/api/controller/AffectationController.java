package com.laposte.api.controller;

import com.laposte.api.entity.Affectation;
import com.laposte.api.repository.AffectationRepository;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/affectations")
@CrossOrigin(origins = "*")
public class AffectationController {

    private final AffectationRepository repo;

    public AffectationController(AffectationRepository repo) {
        this.repo = repo;
    }

    @GetMapping
    public List<Affectation> getAll() {
        return repo.findAll();
    }

    @GetMapping("/{id}")
    public Affectation getById(@PathVariable Integer id) {
        return repo.findById(id).orElse(null);
    }

    @PostMapping
    public Affectation create(@RequestBody Affectation affectation) {
        return repo.save(affectation);
    }

    @PutMapping("/{id}")
    public Affectation update(@PathVariable Integer id, @RequestBody Affectation affectation) {
        affectation.setId(id);
        return repo.save(affectation);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Integer id) {
        repo.deleteById(id);
    }
}