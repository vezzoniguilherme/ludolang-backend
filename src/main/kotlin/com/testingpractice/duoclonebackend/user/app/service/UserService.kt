package com.testingpractice.duoclonebackend.user.app.service

import com.testingpractice.duoclonebackend.catalog.app.service.CourseService
import com.testingpractice.duoclonebackend.commons.exception.ApiException
import com.testingpractice.duoclonebackend.commons.exception.ErrorCode
import com.testingpractice.duoclonebackend.progress.api.dto.UserCourseProgressDto
import com.testingpractice.duoclonebackend.progress.app.mapper.UserCourseProgressMapper
import com.testingpractice.duoclonebackend.progress.app.service.CourseProgressService
import com.testingpractice.duoclonebackend.progress.domain.entity.UserCourseProgress
import com.testingpractice.duoclonebackend.progress.infra.repository.LessonCompletionRepository
import com.testingpractice.duoclonebackend.progress.infra.repository.UserCourseProgressRepository

import com.testingpractice.duoclonebackend.user.api.dto.UserResponse
import com.testingpractice.duoclonebackend.user.app.mapper.UserMapper
import com.testingpractice.duoclonebackend.user.domain.entity.User
import com.testingpractice.duoclonebackend.user.infra.repository.UserRepository
import jakarta.transaction.Transactional
import org.springframework.stereotype.Service
import java.time.Instant

import java.time.LocalDate
import java.time.ZoneId

@Service
open class UserService(
    private val userCourseProgressRepository: UserCourseProgressRepository,
    private val userCourseProgressMapper: UserCourseProgressMapper,
    private val lessonCompletionRepository: LessonCompletionRepository,
    private val userRepository: UserRepository,
    private val courseProgressService: CourseProgressService,
    private val courseService: CourseService,
    private val userMapper: UserMapper
) {

    @Transactional
    open fun getUserCourseProgress(courseId: Int, userId: Int): UserCourseProgressDto {

        var userCourseProgress =
            userCourseProgressRepository.findByUserIdAndCourseId(userId, courseId)

        if (userCourseProgress == null) {
            val newProgress = UserCourseProgress()
            newProgress.userId = userId
            newProgress.courseId = courseId
            newProgress.isComplete = false
            newProgress.currentLessonId =
                courseService.getFirstLessonIdOfCourse(courseId)
            newProgress.updatedAt = Instant.now()

            userCourseProgressRepository.save(newProgress)
            userCourseProgress = newProgress
        }

        var totalLessonCount =
            lessonCompletionRepository.countByUserAndCourse(userId, courseId)

        if (totalLessonCount == null) {
            totalLessonCount = 0
        }

        var lessonSectionId: Int? = null

        if (userCourseProgress.currentLessonId != null) {
            lessonSectionId = courseProgressService.getLessonSectionId(
                userCourseProgress.currentLessonId!!
            )
        }

        return userCourseProgressMapper.toDto(
            userCourseProgress,
            totalLessonCount,
            lessonSectionId
        )
    }

    @Transactional
    open fun getUser(userId: Int): UserResponse {
        val optionalUser = userRepository.findById(userId)

        if (!optionalUser.isPresent) {
            throw ApiException(ErrorCode.USER_NOT_FOUND)
        }

        val user = optionalUser.get()
        potentiallyResetStreak(user)

        return userMapper.toUserResponse(user)
    }

    @Transactional
    open fun getUsersFromIds(userIds: List<Int>?): List<UserResponse> {
        if (userIds == null || userIds.isEmpty()) {
            return emptyList()
        }

        val users = userRepository.findAllById(userIds)
        users.forEach { potentiallyResetStreak(it) }
        return users.map { userMapper.toUserResponse(it) }
    }

    @Transactional
    open fun potentiallyResetStreak(user: User) {
        val lastSubmission = user.lastSubmission ?: return

        val tz = ZoneId.systemDefault()
        val today = LocalDate.now(tz)
        val lastDate = lastSubmission.toInstant().atZone(tz).toLocalDate()

        val isOlder = lastDate.isBefore(today.minusDays(1))

        if (isOlder) {
            user.streakLength = 0
            userRepository.save(user)
        }
    }
}