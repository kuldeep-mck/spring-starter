package com.initiative.banking.entities;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.redis.core.RedisHash;

import java.io.Serializable;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Student implements Serializable {
    @Id @GeneratedValue(strategy = GenerationType.AUTO)
    private String id;
    private String name;
    private String grade;
    private String contactNo;
}
