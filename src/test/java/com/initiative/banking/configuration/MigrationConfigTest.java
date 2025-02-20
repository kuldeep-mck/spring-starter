package com.initiative.banking.configuration;

import org.flywaydb.core.Flyway;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ExtendWith(MockitoExtension.class)
@AutoConfigureTestDatabase
@Import(MigrationConfig.class)
public class MigrationConfigTest {

    @Autowired
    private Flyway flyway;

    @Mock
    private DataSource dataSource;

    @BeforeEach
    void setUp() {
        // Initialize Flyway with the desired configuration before each test.
        flyway = Flyway.configure()
                .dataSource(dataSource)
                .locations("classpath:db/migration")
                .load();
    }

    @Test
    public void testFlyway() {
        // Ensure that the Flyway bean is configured correctly
        assertNotNull(flyway);

        // Validate that Flyway can perform clean and migrate operations
        assertDoesNotThrow(() -> {
            flyway.clean();
            flyway.migrate();
        });

        // Verify that the migrations executed successfully
        assertEquals(0, flyway.info().pending().length);
    }
}
