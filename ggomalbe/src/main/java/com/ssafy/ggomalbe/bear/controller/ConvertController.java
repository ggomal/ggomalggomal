package com.ssafy.ggomalbe.bear.controller;

import com.ssafy.ggomalbe.bear.dto.WordDto;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@RestController
public class ConvertController {

    @GetMapping("/convert")
    public List<WordDto> readCsv() {
        // 추후 return 할 데이터 목록
        List<WordDto> result = new ArrayList<>();
        String path = "src/main/resources/word/wordMeta.csv";

        try {
            BufferedReader br = Files.newBufferedReader(Paths.get(path));
            String line = "";
            int lineCounter = 0;
            while ((line = br.readLine()) != null) {
                lineCounter++;
                String[] temp = line.split(",");
                System.out.println(Arrays.toString(temp));
                if (lineCounter == 1) continue;
                if(temp.length != 5) {return null;}

                boolean flag = temp[4].equals("TRUE");

                WordDto wordDto = WordDto.builder()
                        .letter(temp[0])
                        .pronunciation(temp[1])
                        .initial(temp[2])
                        .syllable(Short.parseShort(temp[3]))
                        .finalityFlag(flag)
                        .build();
                result.add(wordDto);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }
}
