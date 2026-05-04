package com.laposte.api.controller;

import com.laposte.api.entity.Prestation;
import com.laposte.api.repository.PrestationRepository;
import com.laposte.api.repository.TourneeRepository;

import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/prestations")
@CrossOrigin(origins = "*")
public class PrestationController {

    private final PrestationRepository repo;
    private final TourneeRepository tourneeRepo;

    public PrestationController(PrestationRepository repo, TourneeRepository tourneeRepo) {
        this.repo = repo;
        this.tourneeRepo = tourneeRepo;
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

    @PutMapping("/{id}/tournee")
public Prestation setTournee(@PathVariable Integer id, @RequestBody(required = false) Integer idTournee) {
    Prestation p = repo.findById(id).orElse(null);
    if (p == null) return null;
    if (idTournee == null) {
        p.setTournee(null);
    } else {
        p.setTournee(tourneeRepo.findById(idTournee).orElse(null));
    }
    return repo.save(p);
}
}