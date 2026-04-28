package com.laposte.api.controller;

import com.laposte.api.entity.Prestation;
import com.laposte.api.repository.PrestationRepository;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/prestations")
@CrossOrigin(origins = "*")
public class PrestationController {

    private final PrestationRepository repo;

    public PrestationController(PrestationRepository repo) {
        this.repo = repo;
    }

    @GetMapping
    public List<Prestation> getAll() {
        return repo.findAll();
    }

    @GetMapping("/{id}")
    public Prestation getById(@PathVariable Integer id) {
        return repo.findById(id).orElse(null);
    }

    @PostMapping
    public Prestation create(@RequestBody Prestation prestation) {
        return repo.save(prestation);
    }

    @PutMapping("/{id}")
    public Prestation update(@PathVariable Integer id, @RequestBody Prestation prestation) {
        prestation.setId(id);
        return repo.save(prestation);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Integer id) {
        repo.deleteById(id);
    }
}