package it.us.web.util.bean;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.Documented;
import static java.lang.annotation.ElementType.ANNOTATION_TYPE;
import static java.lang.annotation.ElementType.TYPE;
import java.lang.annotation.Retention;
import static java.lang.annotation.RetentionPolicy.RUNTIME;
import java.lang.annotation.Target;

@Target({TYPE, ANNOTATION_TYPE})
@Retention(RUNTIME)
@Constraint(validatedBy = MinLengthDependenciesValidator.class)
@Documented
/**
 * Se l'attributo dependence e'' true, controlla che il campo da validare rispetti la lunghezza minima.
 */
public @interface MinLengthDependencies
{
    String message() default "";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    /**
     * Nome dell'attributo da validare
     */
    String attributo();
    
    /**
     * Nome dell'attributo dependence 
     */
    String dependence();
    
    /**
     * Lunghezza minima che deve avere l'attributo da validare
     */
    int minLength();
    
    
    @Target({TYPE, ANNOTATION_TYPE})
    @Retention(RUNTIME)
    @Documented
    /**
     * Per usare piu'' volte la MinLengthDependencies nello stesso Bean.
     */
    @interface List
    {
        MinLengthDependencies[] value();
    }
}

