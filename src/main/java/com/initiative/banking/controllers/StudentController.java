package com.initiative.banking.controllers;

import com.initiative.banking.dto.CreateStudentDTO;
import com.initiative.banking.entities.Student;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.initiative.banking.services.interfaces.StudentService;

import java.util.List;

@RestController
@RequestMapping("/students")
public class StudentController {

    private final StudentService studentService;

    @Autowired
    public StudentController(StudentService studentService){
        this.studentService = studentService;
    }

    @GetMapping()
    public ResponseEntity<List<Student>> getAllStudents(){
        List<Student> list = studentService.getAllStudents();
        return new ResponseEntity<>(list, HttpStatusCode.valueOf(200));
    }
    @PostMapping()
    public ResponseEntity<Student> createStudent(@RequestBody CreateStudentDTO createStudentDTO){
        Student student = studentService.createStudent(createStudentDTO);
        return new ResponseEntity<>(student, HttpStatusCode.valueOf(201));
    }

    @GetMapping("/{studentId}")
    public ResponseEntity<Student> getStudentById(@PathVariable String studentId){
        Student student = studentService.getStudentById(studentId);
        return new ResponseEntity<>(student, HttpStatusCode.valueOf(200));
    }
}
