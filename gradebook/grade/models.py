from django.db import models

class User(auth.models.AbstractUser):
    id = models.IntegerField()
    email = models.CharField(max_length=200)
    username = models.CharField(max_length=100)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    password = models.CharField(max_length=100)
    user_type = models.CharField(max_length=50)

    class Meta:
        # Prevents creation of table in db
        # Removed when sub classed
        # https://docs.djangoproject.com/en/3.2/topics/db/models/#abstract-base-classes
        abstract = True

class GradeSystem(models.Model):
    pass

class Teacher(models.Model):
    pass


class Student(models.Model):
    pass

class Subject(models.Model):
    pass


class GradeValue(models.Model):
    grade_type = models.ForeignKey(GradeSystem, on_delete=models.CASCADE)


class SchoolYear(models.Model):
    grade_system = models.ForeignKey(GradeSystem, on_delete=models.CASCADE)
    start_of_year = models.DateField()
    end_of_year = models.DateField()


class Class(models.Model):
    id = models.IntegerField()
    class_prefix = models.IntegerField()
    class_suffix = models.CharField(max_length=50)
    year = models.ForeignKey(SchoolYear, on_delete=models.CASCADE)
    tutor = models.ForeignKey(Teacher, on_delete=models.CASCADE)
    sub_class_of = models.IntegerField(default=0)
    class Meta:
        abstract = True

class SubClass(models.Model):
    from_ = models.ForeignKey(Class, on_delete=models.CASCADE)
    to_ = models.ForeignKey(Class, on_delete=models.CASCADE)


class GradeColumn(models.Model):
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE)
    class_ = models.ForeignKey(Class, on_delete=models.CASCADE)

class Grade(models.Model):
    grade = models.ForeignKey(GradeValue, on_delete=models.CASCADE)
    created_by = models.ForeignKey(Teacher, on_delete=models.CASCADE)
    assigned_to = models.ForeignKey(Student, on_delete=models.CASCADE)
    grade_column = models.ForeignKey(GradeColumn, on_delete=models.CASCADE)


class AssignedClass(models.Model):
    class_id = models.ForeignKey(Class, on_delete=models.CASCADE)
    student_id = models.ForeignKey(Student, on_delete=models.CASCADE)


def school_models_factory(school_name: str) -> Dict[str, Type[models.Model]]:
    #  We can move it to class and use classmethods as decorators to not have
    # to create models explicitly


    class User_(User):
        class Meta:
            # Sets the name of the table inside database
            db_table = f'{school_name}_user'


    class Class_(Class):
        class Meta:
            db_table = f'{school_name}_class'

    class Student(User_):
        class Meta:
            # Signals Django, that this model is used only for overriding Python methods from base class
            # It doesn't create a new database table
            proxy = True

    ...

    return {
        'user': User_,
        'class': Class_,
        'student': Student,
        ...
    }


def load_school_models() -> None:
    school_names: List[str] = get_school_names()

    for i in school_names:
        school_models = school_models_factory(i)
        register_school_models(i, school_models)


load_school_models()