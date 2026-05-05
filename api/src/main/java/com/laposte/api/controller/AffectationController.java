package com.laposte.api.controller;

import com.laposte.api.entity.Affectation;
import com.laposte.api.repository.AffectationRepository;
import com.laposte.api.repository.FacteurRepository;
import com.laposte.api.repository.TourneeRepository;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/affectations")
@CrossOrigin(origins = "*")
public class AffectationController {

    private final AffectationRepository repo;
    private final FacteurRepository facteurRepo;
    private final TourneeRepository tourneeRepo;

    public AffectationController(AffectationRepository repo, FacteurRepository facteurRepo, TourneeRepository tourneeRepo) {
        this.repo = repo;
        this.facteurRepo = facteurRepo;
        this.tourneeRepo = tourneeRepo;
    }

    @GetMapping
    public List<Affectation> getAll() {
        return repo.findAll();
    }

    @GetMapping("/{id}")
    public Affectation getById(@PathVariable Integer id) {
        return repo.findById(id).orElse(null);
    }

    @PostMapping("/simple")
    public Affectation createSimple(@RequestBody Map<String, Object> body) {
        Affectation a = new Affectation();
        a.setFacteur(facteurRepo.findById((Integer) body.get("idFacteur")).orElse(null));
        a.setTournee(tourneeRepo.findById((Integer) body.get("idTournee")).orElse(null));
        a.setDateDebut(java.time.LocalDate.parse((String) body.get("dateDebut")));
        a.setRoleAffectation((String) body.get("roleAffectation"));
        return repo.save(a);
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