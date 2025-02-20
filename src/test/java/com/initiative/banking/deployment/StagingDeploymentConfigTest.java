package com.initiative.banking.deployment;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.jupiter.MockitoExtension;
import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
public class StagingDeploymentConfigTest {

    @Mock
    private ConfigurationService configurationService;

    @InjectMocks
    private StagingDeploymentConfig stagingDeploymentConfig;

    @BeforeEach
    void setup() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testProvideDeploymentConfig() {
        DeploymentConfig expectedConfig = new DeploymentConfig();
        expectedConfig.setEnvironment("staging");
        expectedConfig.setUrl("http://staging.example.com");

        when(configurationService.getDeploymentConfig("staging")).thenReturn(expectedConfig);

        DeploymentConfig actualConfig = stagingDeploymentConfig.provideDeploymentConfig();

        assertNotNull(actualConfig);
        assertEquals(expectedConfig.getEnvironment(), actualConfig.getEnvironment());
        assertEquals(expectedConfig.getUrl(), actualConfig.getUrl());

        verify(configurationService, times(1)).getDeploymentConfig("staging");
    }

    @Test
    public void testValidateDeploymentConfig() {
        DeploymentConfig validConfig = new DeploymentConfig();
        validConfig.setEnvironment("staging");
        validConfig.setUrl("http://staging.example.com");

        DeploymentConfig invalidConfig = new DeploymentConfig();
        invalidConfig.setEnvironment(null);
        invalidConfig.setUrl(null);

        assertDoesNotThrow(() -> stagingDeploymentConfig.validateDeploymentConfig(validConfig));
        Exception exception = assertThrows(RuntimeException.class, () -> stagingDeploymentConfig.validateDeploymentConfig(invalidConfig));

        String expectedMessage = "Invalid configuration";
        String actualMessage = exception.getMessage();

        assertTrue(actualMessage.contains(expectedMessage));
    }
}
