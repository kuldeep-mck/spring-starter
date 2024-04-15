package com.initiative.banking.services;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.boot.test.context.SpringBootTest;
import com.initiative.banking.dto.CreateStudentDTO;
import com.initiative.banking.entities.Student;
import com.initiative.banking.repositories.StudentRepository;
import com.initiative.banking.services.interfaces.StudentService;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@SpringBootTest
@ExtendWith(MockitoExtension.class)
public class StudentServiceTest {

    @Mock
    private StudentRepository studentRepository;

    @InjectMocks
    private StudentService studentService;

    @Test
    public void createStudentTest(){
        CreateStudentDTO createStudentDto = new CreateStudentDTO();
        createStudentDto.setName("Test");
        createStudentDto.setGrade("A");
        createStudentDto.setContactNo("976543");
        when(studentRepository.save(any())).thenReturn(new Student());
        Student student = studentService.createStudent(createStudentDto);
        Assertions.assertNotNull(student);
    }
    @Test
    public void getStudentByIdTest(){
        when(studentRepository.findById(any())).thenReturn(Optional.of(new Student()));
        Student student = studentService.getStudentById("1");
        Assertions.assertNotNull(student);
    }
    @Test
    public void getAllStudentsTest(){
        List<Student> l = new ArrayList<>();
        l.add(new Student("1", "Test", "A", "12345"));
        when(studentRepository.findAll()).thenReturn(l);
        List<Student> list = studentService.getAllStudents();
        Assertions.assertEquals(1, list.size());
    }
}
