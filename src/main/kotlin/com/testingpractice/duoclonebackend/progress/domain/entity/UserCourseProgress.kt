package com.testingpractice.duoclonebackend.progress.domain.entity

import jakarta.persistence.*
import org.hibernate.annotations.UpdateTimestamp
import java.time.Instant

@Entity
@Table(name = "user_course_progress")
class UserCourseProgress(

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id: Int? = null,

    @Column(name = "user_id")
    var userId: Int? = null,

    @Column(name = "course_id")
    var courseId: Int? = null,

    @Column(name = "is_complete")
    var isComplete: Boolean? = null,

    @Column(name = "current_lesson_id")
    var currentLessonId: Int? = null,

    @UpdateTimestamp
    @Column(name = "updated_at")
    var updatedAt: Instant? = null
)