package com.example.demo.auth;

import com.example.demo.model.User;
import com.example.demo.model.UserRepository;

import lombok.RequiredArgsConstructor;

import java.util.Optional;

import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class LoginUserDetailsService implements UserDetailsService {

    private final UserRepository repository;

    @Override
    public LoginUserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Optional<User> maybeUser = repository.findByEmail(username);
        return maybeUser.map(LoginUserDetails::new)
                .orElseThrow(() -> new UsernameNotFoundException("user not found."));
    }
}
