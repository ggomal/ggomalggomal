package com.ssafy.ggomalbe.bear.controller;

import com.ssafy.ggomalbe.bear.dto.WordRequest;
import com.ssafy.ggomalbe.common.entity.WordEntity;
import com.ssafy.ggomalbe.common.service.NaverCloudClient;
import lombok.RequiredArgsConstructor;
import org.springframework.http.codec.multipart.FilePart;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@RestController
@RequiredArgsConstructor
public class ConvertController {

    private final WordController wordController;
    private final NaverCloudClient naverCloudClient;

    // csv file -> wordRequest List
    @GetMapping("/convert")
    public List<WordRequest> readCsv() {
        // 추후 return 할 데이터 목록
        List<WordRequest> result = new ArrayList<>();
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
//                if (temp.length != 7) {return null;}

                WordRequest wordRequest = WordRequest.builder()
                        .letter(temp[0])
                        .pronunciation(temp[1])
                        .syllable(Short.parseShort(temp[2]))
                        .initial(temp[3])
                        .finality(temp[4])
                        .letterImgUrl(temp[5])
//                        .soundUrl(Objects.equals(temp[6],"") ? null)  // sound 는 voice를 받아서 입력하자.
                        .build();
                result.add(wordRequest);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }


    // csv file -> wordRequest List
    @GetMapping("/saveCsv")
    public Mono<Integer> saveCsv(@RequestParam String fileName) {
        // 추후 return 할 데이터 목록
        List<WordRequest> result = new ArrayList<>();
        String path = "src/main/resources/word/"+fileName+".csv";

        try {
            BufferedReader br = Files.newBufferedReader(Paths.get(path));
            String line = "";
            int lineCounter = 0;
            while ((line = br.readLine()) != null) {
                lineCounter++;
                String[] temp = line.split(",");
                System.out.println(Arrays.toString(temp));
                if (lineCounter == 1) continue;

                WordRequest wordRequest = WordRequest.builder()
                        .letter(temp[0])
                        .pronunciation(temp[1])
                        .syllable(Short.parseShort(temp[2]))
                        .initial(temp[3])
                        .finality(temp[4])
                        .letterImgUrl(temp[5])
                        .build();
                result.add(wordRequest);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        Flux<WordEntity> resultList = wordController.saveAll(result);
        System.out.println("단어 저장 : " + resultList.log());

        return resultList.collectList().map(List::size);
    }


    @GetMapping(value = "/saveSound")
    public Mono<Integer> saveSound(@RequestParam String fileName) {
        // csv 파일로부터 저장할 단어 리스트 추출
        List<String> request = new ArrayList<>();
        String path = "src/main/resources/word/"+fileName+".csv";

        try {
            BufferedReader br = Files.newBufferedReader(Paths.get(path));
            String line = "";
            int lineCounter = 0;
            while ((line = br.readLine()) != null) {
                lineCounter++;
                String[] temp = line.split(",");
                System.out.println(temp[0]);

                if (lineCounter == 1) continue;

                request.add(temp[0]);
            }

            // 네이버 클로바 api에서 음성 받아와서 저장 후 s3 url 리스트 반환
            // naverCloudClient.getWordSound(request)

            // 음성파일 s3 url -> db 업데이트
            // updateSoundUrlByLetter()


        } catch (IOException e) {
            e.printStackTrace();
        }


    }

}
