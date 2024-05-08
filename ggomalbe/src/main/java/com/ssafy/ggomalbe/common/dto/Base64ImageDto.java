package com.ssafy.ggomalbe.common.dto;

import jakarta.xml.bind.DatatypeConverter;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Setter
@Getter
public class Base64ImageDto {

    private byte[] imageBytes;
    private String fileName;
    private String fileType;
    private boolean hasErrors;
    private List<String> errorMessages;
    private static final List<String> VALID_FILE_TYPES = new ArrayList<String>(3);

    static {
        VALID_FILE_TYPES.add("jpg");
        VALID_FILE_TYPES.add("jpeg");
        VALID_FILE_TYPES.add("png");
    }

    public Base64ImageDto(String b64ImageData, String fileName) {
        this.fileName = fileName;
        this.errorMessages = new ArrayList<>(2);
        String[] base64Components = b64ImageData.split(",");

        if (base64Components.length != 2) {
            this.hasErrors = true;
            this.errorMessages.add("Invalid base64 data: " + b64ImageData);
        }

        if (!this.hasErrors) {
            String base64Data = base64Components[0];
            this.fileType = base64Data.substring(base64Data.indexOf('/') + 1, base64Data.indexOf(';'));

            if (!VALID_FILE_TYPES.contains(fileType)) {
                this.hasErrors = true;
                this.errorMessages.add("Invalid file type: " + fileType);
            }

            if (!this.hasErrors) {
                String base64Image = base64Components[1];
                this.imageBytes = DatatypeConverter.parseBase64Binary(base64Image);
            }
        }
    }

}
