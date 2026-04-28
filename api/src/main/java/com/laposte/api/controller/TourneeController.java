package com.laposte.api.controller;

import com.laposte.api.entity.Tournee;
import com.laposte.api.repository.TourneeRepository;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/tournees")
@CrossOrigin(origins = "*")
public class TourneeController {

    private final TourneeRepository repo;

    public TourneeController(TourneeRepository repo) {
        this.repo = repo;
    }

    @GetMapping
    public List<Tournee> getAll() {
        return repo.findAll();
    }

    @GetMapping("/{id}")
    public Tournee getById(@PathVariable Integer id) {
        return repo.findById(id).orElse(null);
    }

    @PostMapping
    public Tournee create(@RequestBody Tournee tournee) {
        return repo.save(tournee);
    }

    @PutMapping("/{id}")
    public Tournee update(@PathVariable Integer id, @RequestBody Tournee tournee) {
        tournee.setId(id);
        return repo.save(tournee);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Integer id) {
        repo.deleteById(id);
    }
}