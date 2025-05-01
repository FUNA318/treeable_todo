package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.model.UserRepository;
import com.example.demo.auth.JwtService;
import com.example.demo.auth.LoginUserDetails;
import com.example.demo.form.UserForm;

import lombok.RequiredArgsConstructor;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final UserRepository userRepository;
    private final JwtService jwtService;

    @Autowired
    PasswordEncoder passwordEncoder;

    @PostMapping("/signup")
    public String signup(@RequestBody User user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        User createdUser = userRepository.save(user);
        UsernamePasswordAuthenticationToken authenticationToken = 
                new UsernamePasswordAuthenticationToken(createdUser.getEmail(), createdUser.getPassword());
        authenticationManager.authenticate(authenticationToken);
        JwtService.JwtToken token = jwtService.generateToken(createdUser.getEmail());
        return token.token();
    }

    @PostMapping("/login")
    public String login(@RequestBody UserForm request) {
        UsernamePasswordAuthenticationToken authenticationToken = 
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword());
        authenticationManager.authenticate(authenticationToken);
        JwtService.JwtToken token = jwtService.generateToken(request.getEmail());

        return token.token();
    }

    @GetMapping("/user")
    public Optional<User> user(@AuthenticationPrincipal LoginUserDetails userDetails) {
        Optional<User> maybeUser = userRepository.findByEmail(userDetails.getUsername());
        return maybeUser;
    }
}
