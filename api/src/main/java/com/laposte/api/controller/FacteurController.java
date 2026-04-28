package com.laposte.api.controller;

import com.laposte.api.entity.Facteur;
import com.laposte.api.repository.FacteurRepository;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/facteurs")
@CrossOrigin(origins = "*")
public class FacteurController {

    private final FacteurRepository repo;

    public FacteurController(FacteurRepository repo) {
        this.repo = repo;
    }

    @GetMapping
    public List<Facteur> getAll() {
        return repo.findAll();
    }

    @GetMapping("/{id}")
    public Facteur getById(@PathVariable Integer id) {
        return repo.findById(id).orElse(null);
    }

    @PostMapping
    public Facteur create(@RequestBody Facteur facteur) {
        return repo.save(facteur);
    }

    @PutMapping("/{id}")
    public Facteur update(@PathVariable Integer id, @RequestBody Facteur facteur) {
        facteur.setId(id);
        return repo.save(facteur);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Integer id) {
        repo.deleteById(id);
    }
}