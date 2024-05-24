package com.ssafy.ggomalbe.bear.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.web.bind.annotation.RequestPart;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
public class BearRecordRequest {
    private Long wordId;

    private String letter;

//    private FilePart kidVoice;

    private Short pronCount;

}
