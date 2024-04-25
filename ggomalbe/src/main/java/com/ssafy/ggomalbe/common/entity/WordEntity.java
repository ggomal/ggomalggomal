package com.ssafy.ggomalbe.common.entity;

import lombok.Builder;
import org.springframework.data.relational.core.mapping.Table;

@Table("member")
@Builder
public class WordEntity extends AbstractEntity {
}
