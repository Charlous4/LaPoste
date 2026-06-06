package com.laposte.api.controller;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.laposte.api.entity.Affectation;
import com.laposte.api.repository.AffectationRepository;
import com.laposte.api.repository.FacteurRepository;
import com.laposte.api.repository.TourneeRepository;

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
        
        // 1. On affecte le facteur
        a.setFacteur(facteurRepo.findById((Integer) body.get("idFacteur")).orElse(null));
        
        // 2. LA CORRECTION : On vérifie si idTournee est null avant de chercher
        Integer idTournee = (Integer) body.get("idTournee");
        if (idTournee != null) {
            a.setTournee(tourneeRepo.findById(idTournee).orElse(null));
        } else {
            a.setTournee(null); // Gère le cas "Aucune tournée"
        }
        
        // 3. On ajoute les autres infos
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