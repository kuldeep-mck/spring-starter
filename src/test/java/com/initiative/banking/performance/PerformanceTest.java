package com.initiative.banking.performance;

import com.initiative.banking.configuration.HttpClientConfig;
import com.initiative.banking.controllers.StudentController;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.web.client.RestTemplate;
import org.yaml.snakeyaml.Yaml;

import java.io.InputStream;
import java.util.Map;

import static org.mockito.Mockito.mock;

@SpringBootTest
public class PerformanceTest {

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private StudentController studentController;

    private Map<String, Object> performanceTestConfig;

    @BeforeEach
    void setup() {
        MockitoAnnotations.openMocks(this);
        restTemplate = new HttpClientConfig().configure();

        // Load performance test config
        Yaml yaml = new Yaml();
        try (InputStream in = getClass().getResourceAsStream("/performance/PerformanceTestConfig.yaml")) {
            performanceTestConfig = yaml.load(in);
        } catch (Exception e) {
            throw new RuntimeException("Failed to load performance test configuration", e);
        }
    }

    @Test
    void executeLoadTest() {
        // Example load test logic
        int virtualUsers = (int) performanceTestConfig.get("virtual_users");

        for (int i = 0; i < virtualUsers; i++) {
            try {
                studentController.getAllStudents();
            } catch (Exception e) {
                // Handle exception
            }
        }

        // Evaluating application's behavior under load could include measuring response times, error rates, etc.
        // This is a simplified example for demonstration purposes.
    }

    @Test
    void executeStressTest() {
        // Example stress test logic
        int initialUsers = (int) performanceTestConfig.get("initial_users");
        int maxUsers = (int) performanceTestConfig.get("max_users");

        for (int i = initialUsers; i <= maxUsers; i++) {
            try {
                studentController.createStudent(mockStudent());
            } catch (Exception e) {
                // Handle exception
            }
        }
    }

    @Test
    void executeSpikeTest() {
        // Example spike test logic
        // This simulates a sudden spike in the number of users
        int spikeUsers = (int) performanceTestConfig.get("spike_users");

        for (int i = 0; i < spikeUsers; i++) {
            try {
                studentController.createStudent(mockStudent());
            } catch (Exception e) {
                // Handle exception
            }
        }
    }

    private CreateStudentDTO mockStudent() {
        CreateStudentDTO studentDTO = new CreateStudentDTO();
        studentDTO.setName("Spike Load Test");
        studentDTO.setGrade("A");
        studentDTO.setContactNo("123456789");
        return studentDTO;
    }

    @AfterEach
    void tearDown() {
        // Clean up resources and reset application state
        performanceTestConfig.clear();
    }
}
