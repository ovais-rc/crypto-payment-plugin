package com.ibm.commerce.ue.rest;

import com.ibm.commerce.ue.rest.BaseResource;

import io.swagger.annotations.Info;
import io.swagger.annotations.SwaggerDefinition;

/*
 * High-level Swagger Definitions used to display information in Swagger UI
 */

@SwaggerDefinition(
        info = @Info(
                description = "API Extensions for IBM Commerce on Cloud customization.",
                version = "1.4",
                title = "IBM Commerce on Cloud API Extensions"
        )
)
public class SwaggerDefinitions extends BaseResource {}