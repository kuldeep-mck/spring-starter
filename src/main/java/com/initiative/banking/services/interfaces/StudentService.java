package com.initiative.banking.services.interfaces;

import com.initiative.banking.dto.CreateStudentDTO;
import com.initiative.banking.entities.Student;

import java.util.List;

public interface StudentService {
   Student createStudent(CreateStudentDTO createStudentDto);
   Student getStudentById(String id);
   List<Student> getAllStudents();
}
