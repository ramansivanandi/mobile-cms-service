package com.dynamicui.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDateTime;

@Table("images")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Image {

    @Id
    @Column("id")
    private Long id;

    @Column("file_name")
    private String fileName;

    @Column("content_type")
    private String contentType;

    @Column("file_size")
    private Long fileSize;

    // Stores only the UUID-based filename, never the full path
    @Column("file_path")
    private String filePath;

    @Column("created_at")
    private LocalDateTime createdAt;
}
