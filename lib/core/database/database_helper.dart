import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'database_seeder.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'commerceiq.db');

    return await openDatabase(
      path,
      version: 10,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        // Drop all tables and recreate with fresh seed data
        await db.execute('DROP TABLE IF EXISTS recently_viewed');
        await db.execute('DROP TABLE IF EXISTS bookmarks');
        await db.execute('DROP TABLE IF EXISTS checklist_progress');
        await db.execute('DROP TABLE IF EXISTS progress');
        await db.execute('DROP TABLE IF EXISTS checklist_items');
        await db.execute('DROP TABLE IF EXISTS lessons');
        await db.execute('DROP TABLE IF EXISTS courses');
        await db.execute('DROP TABLE IF EXISTS categories');
        await _onCreate(db, newVersion);
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        emoji TEXT NOT NULL,
        description TEXT,
        color_hex TEXT,
        sort_order INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE courses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        subtitle TEXT,
        description TEXT,
        emoji TEXT NOT NULL,
        badge_label TEXT,
        badge_type TEXT,
        expected_roi TEXT,
        investment_level TEXT,
        time_required TEXT,
        difficulty TEXT,
        total_steps INTEGER DEFAULT 0,
        sort_order INTEGER DEFAULT 0,
        FOREIGN KEY (category_id) REFERENCES categories(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE lessons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        course_id INTEGER NOT NULL,
        step_number INTEGER NOT NULL,
        category_label TEXT,
        title TEXT NOT NULL,
        description TEXT,
        content TEXT,
        expert_insight TEXT,
        youtube_id TEXT,
        reading_minutes INTEGER DEFAULT 5,
        sort_order INTEGER DEFAULT 0,
        FOREIGN KEY (course_id) REFERENCES courses(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE checklist_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lesson_id INTEGER NOT NULL,
        label TEXT,
        content TEXT NOT NULL,
        sort_order INTEGER DEFAULT 0,
        FOREIGN KEY (lesson_id) REFERENCES lessons(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lesson_id INTEGER NOT NULL UNIQUE,
        course_id INTEGER NOT NULL,
        is_completed INTEGER DEFAULT 0,
        completed_at TEXT,
        FOREIGN KEY (lesson_id) REFERENCES lessons(id),
        FOREIGN KEY (course_id) REFERENCES courses(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE checklist_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        checklist_item_id INTEGER NOT NULL UNIQUE,
        lesson_id INTEGER NOT NULL,
        is_checked INTEGER DEFAULT 0,
        checked_at TEXT,
        FOREIGN KEY (checklist_item_id) REFERENCES checklist_items(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lesson_id INTEGER,
        course_id INTEGER,
        bookmarked_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE recently_viewed (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        course_id INTEGER,
        lesson_id INTEGER,
        viewed_at TEXT NOT NULL
      )
    ''');

    // Seed data after creating tables
    await DatabaseSeeder.seed(db);
  }

  // --- CATEGORY QUERIES ---
  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return db.query('categories', orderBy: 'sort_order ASC');
  }

  Future<Map<String, dynamic>?> getCategoryById(int id) async {
    final db = await database;
    final result = await db.query('categories', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // --- COURSE QUERIES ---
  Future<List<Map<String, dynamic>>> getCoursesByCategory(int categoryId) async {
    final db = await database;
    return db.query('courses', where: 'category_id = ?', whereArgs: [categoryId], orderBy: 'sort_order ASC');
  }

  Future<List<Map<String, dynamic>>> getCoursesByCategoryFiltered(int categoryId, String filter) async {
    final db = await database;
    if (filter == 'all') {
      return getCoursesByCategory(categoryId);
    }
    return db.query('courses',
      where: 'category_id = ? AND badge_type = ?',
      whereArgs: [categoryId, filter],
      orderBy: 'sort_order ASC',
    );
  }

  Future<Map<String, dynamic>?> getCourseById(int id) async {
    final db = await database;
    final result = await db.query('courses', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getFeaturedCourses({int limit = 5}) async {
    final db = await database;
    return db.query('courses', orderBy: 'RANDOM()', limit: limit);
  }

  Future<List<Map<String, dynamic>>> getAllCourses() async {
    final db = await database;
    return db.query('courses', orderBy: 'sort_order ASC');
  }

  // --- LESSON QUERIES ---
  Future<List<Map<String, dynamic>>> getLessonsByCourse(int courseId) async {
    final db = await database;
    return db.query('lessons', where: 'course_id = ?', whereArgs: [courseId], orderBy: 'step_number ASC');
  }

  Future<Map<String, dynamic>?> getLessonById(int id) async {
    final db = await database;
    final result = await db.query('lessons', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // --- CHECKLIST QUERIES ---
  Future<List<Map<String, dynamic>>> getChecklistItems(int lessonId) async {
    final db = await database;
    return db.query('checklist_items', where: 'lesson_id = ?', whereArgs: [lessonId], orderBy: 'sort_order ASC');
  }

  // --- PROGRESS ---
  Future<Map<String, dynamic>?> getLessonProgress(int lessonId) async {
    final db = await database;
    final result = await db.query('progress', where: 'lesson_id = ?', whereArgs: [lessonId]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getCourseProgress(int courseId) async {
    final db = await database;
    return db.query('progress', where: 'course_id = ?', whereArgs: [courseId]);
  }

  Future<void> saveLessonProgress(int lessonId, int courseId, bool completed) async {
    final db = await database;
    await db.insert('progress', {
      'lesson_id': lessonId,
      'course_id': courseId,
      'is_completed': completed ? 1 : 0,
      'completed_at': completed ? DateTime.now().toIso8601String() : null,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // --- CHECKLIST PROGRESS ---
  Future<Map<int, bool>> getChecklistProgress(int lessonId) async {
    final db = await database;
    final results = await db.query('checklist_progress', where: 'lesson_id = ?', whereArgs: [lessonId]);
    final map = <int, bool>{};
    for (final row in results) {
      map[row['checklist_item_id'] as int] = (row['is_checked'] as int) == 1;
    }
    return map;
  }

  Future<void> saveChecklistItemProgress(int checklistItemId, int lessonId, bool checked) async {
    final db = await database;
    await db.insert('checklist_progress', {
      'checklist_item_id': checklistItemId,
      'lesson_id': lessonId,
      'is_checked': checked ? 1 : 0,
      'checked_at': checked ? DateTime.now().toIso8601String() : null,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // --- BOOKMARKS ---
  Future<List<Map<String, dynamic>>> getBookmarkedCourses() async {
    final db = await database;
    return db.rawQuery('''
      SELECT c.*, b.id as bookmark_id, b.bookmarked_at
      FROM bookmarks b
      INNER JOIN courses c ON b.course_id = c.id
      WHERE b.course_id IS NOT NULL
      ORDER BY b.bookmarked_at DESC
    ''');
  }

  Future<List<Map<String, dynamic>>> getBookmarkedLessons() async {
    final db = await database;
    return db.rawQuery('''
      SELECT l.*, b.id as bookmark_id, b.bookmarked_at, c.title as course_title
      FROM bookmarks b
      INNER JOIN lessons l ON b.lesson_id = l.id
      INNER JOIN courses c ON l.course_id = c.id
      WHERE b.lesson_id IS NOT NULL
      ORDER BY b.bookmarked_at DESC
    ''');
  }

  Future<bool> isCourseBookmarked(int courseId) async {
    final db = await database;
    final result = await db.query('bookmarks', where: 'course_id = ?', whereArgs: [courseId]);
    return result.isNotEmpty;
  }

  Future<bool> isLessonBookmarked(int lessonId) async {
    final db = await database;
    final result = await db.query('bookmarks', where: 'lesson_id = ?', whereArgs: [lessonId]);
    return result.isNotEmpty;
  }

  Future<void> toggleCourseBookmark(int courseId) async {
    final db = await database;
    final existing = await db.query('bookmarks', where: 'course_id = ?', whereArgs: [courseId]);
    if (existing.isNotEmpty) {
      await db.delete('bookmarks', where: 'course_id = ?', whereArgs: [courseId]);
    } else {
      await db.insert('bookmarks', {
        'course_id': courseId,
        'bookmarked_at': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> toggleLessonBookmark(int lessonId) async {
    final db = await database;
    final existing = await db.query('bookmarks', where: 'lesson_id = ?', whereArgs: [lessonId]);
    if (existing.isNotEmpty) {
      await db.delete('bookmarks', where: 'lesson_id = ?', whereArgs: [lessonId]);
    } else {
      await db.insert('bookmarks', {
        'lesson_id': lessonId,
        'bookmarked_at': DateTime.now().toIso8601String(),
      });
    }
  }

  // --- RECENTLY VIEWED ---
  Future<List<Map<String, dynamic>>> getRecentlyViewed({int limit = 10}) async {
    final db = await database;
    return db.rawQuery('''
      SELECT rv.*, 
        c.title as course_title, c.emoji as course_emoji,
        l.title as lesson_title, l.step_number
      FROM recently_viewed rv
      LEFT JOIN courses c ON rv.course_id = c.id
      LEFT JOIN lessons l ON rv.lesson_id = l.id
      ORDER BY rv.viewed_at DESC
      LIMIT ?
    ''', [limit]);
  }

  Future<void> addRecentlyViewed({int? courseId, int? lessonId}) async {
    final db = await database;
    // Remove old entry for same item
    if (courseId != null) {
      await db.delete('recently_viewed', where: 'course_id = ?', whereArgs: [courseId]);
    }
    if (lessonId != null) {
      await db.delete('recently_viewed', where: 'lesson_id = ?', whereArgs: [lessonId]);
    }
    await db.insert('recently_viewed', {
      'course_id': courseId,
      'lesson_id': lessonId,
      'viewed_at': DateTime.now().toIso8601String(),
    });
    // Keep only last 20
    await db.rawDelete('''
      DELETE FROM recently_viewed WHERE id NOT IN (
        SELECT id FROM recently_viewed ORDER BY viewed_at DESC LIMIT 20
      )
    ''');
  }

  // --- SEARCH ---
  Future<List<Map<String, dynamic>>> searchCourses(String query) async {
    final db = await database;
    return db.query('courses',
      where: 'title LIKE ? OR description LIKE ? OR subtitle LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
  }

  Future<List<Map<String, dynamic>>> searchLessons(String query) async {
    final db = await database;
    return db.rawQuery('''
      SELECT l.*, c.title as course_title
      FROM lessons l
      INNER JOIN courses c ON l.course_id = c.id
      WHERE l.title LIKE ? OR l.description LIKE ? OR l.content LIKE ? OR l.category_label LIKE ?
    ''', ['%$query%', '%$query%', '%$query%', '%$query%']);
  }

  // --- STATS ---
  Future<int> getCompletedCoursesCount() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT COUNT(DISTINCT p.course_id) as count
      FROM progress p
      INNER JOIN courses c ON p.course_id = c.id
      WHERE p.course_id IN (
        SELECT course_id FROM progress 
        GROUP BY course_id
        HAVING COUNT(CASE WHEN is_completed = 1 THEN 1 END) = (
          SELECT total_steps FROM courses WHERE id = progress.course_id
        )
      )
    ''');
    return (result.first['count'] as int?) ?? 0;
  }

  Future<int> getCompletedLessonsCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM progress WHERE is_completed = 1'
    );
    return (result.first['count'] as int?) ?? 0;
  }

  Future<List<Map<String, dynamic>>> getInProgressCourses() async {
    final db = await database;
    return db.rawQuery('''
      SELECT c.*, 
        COUNT(CASE WHEN p.is_completed = 1 THEN 1 END) as completed_steps,
        c.total_steps
      FROM courses c
      INNER JOIN progress p ON p.course_id = c.id
      GROUP BY c.id
      HAVING completed_steps > 0 AND completed_steps < c.total_steps
      ORDER BY MAX(p.completed_at) DESC
    ''');
  }

  Future<Map<String, dynamic>?> getLastAccessedCourse() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT c.*, 
        COUNT(CASE WHEN p.is_completed = 1 THEN 1 END) as completed_steps
      FROM recently_viewed rv
      INNER JOIN courses c ON rv.course_id = c.id
      LEFT JOIN progress p ON p.course_id = c.id
      GROUP BY c.id
      ORDER BY rv.viewed_at DESC
      LIMIT 1
    ''');
    return result.isNotEmpty ? result.first : null;
  }
}
