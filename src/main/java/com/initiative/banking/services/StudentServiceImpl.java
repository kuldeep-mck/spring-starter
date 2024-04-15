package com.initiative.banking.services;

import com.initiative.banking.dto.CreateStudentDTO;
import com.initiative.banking.entities.Student;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.initiative.banking.repositories.StudentRepository;
import com.initiative.banking.services.interfaces.StudentService;

import java.util.ArrayList;
import java.util.List;

@Service
public class StudentServiceImpl implements StudentService {

    private final StudentRepository studentRepository;

    @Autowired
    public StudentServiceImpl(StudentRepository studentRepository){
        this.studentRepository = studentRepository;
    }

    public Student createStudent(CreateStudentDTO createStudentDto){
        Student student = this.dtoToEntity(createStudentDto);
        Student savedStudent = studentRepository.save(student);
        return savedStudent;
    }

    public Student getStudentById(String id){
        Student student = studentRepository.findById(id).orElse(null);
        return student;
    }

    public List<Student> getAllStudents(){
        List<Student> allStudents = new ArrayList<>();
        studentRepository.findAll().forEach(student -> allStudents.add(student));
        return allStudents;
    }

    private Student dtoToEntity(CreateStudentDTO createStudentDto) {
        Student student = new Student();
        student.setName(createStudentDto.getName());
        student.setGrade(createStudentDto.getGrade());
        student.setContactNo(createStudentDto.getContactNo());
        return student;
    }
}
