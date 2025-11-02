package com.example.authapp_expt12;

import androidx.appcompat.app.AppCompatActivity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.google.firebase.auth.FirebaseAuth;

public class SignupActivity extends AppCompatActivity {

    EditText signupEmail, signupPassword;
    Button btnSignup;
    FirebaseAuth mAuth;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_signup);

        signupEmail = findViewById(R.id.signupEmail);
        signupPassword = findViewById(R.id.signupPassword);
        btnSignup = findViewById(R.id.btnSignup);

        mAuth = FirebaseAuth.getInstance();

        btnSignup.setOnClickListener(v -> {
            String email = signupEmail.getText().toString();
            String pass = signupPassword.getText().toString();

            if(email.isEmpty() || pass.isEmpty()){
                Toast.makeText(this, "Fill all fields", Toast.LENGTH_SHORT).show();
                return;
            }

            mAuth.createUserWithEmailAndPassword(email, pass).addOnCompleteListener(task -> {
                if(task.isSuccessful()){
                    Toast.makeText(this, "Account Created", Toast.LENGTH_SHORT).show();
                    startActivity(new Intent(SignupActivity.this, MainActivity.class));
                    finish();
                } else {
                    Toast.makeText(this, "Signup Failed", Toast.LENGTH_SHORT).show();
                }
            });
        });
    }
}
