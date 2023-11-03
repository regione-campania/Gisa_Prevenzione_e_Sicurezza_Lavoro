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
@Constraint(validatedBy = NotNullDependenciesValidator.class)
/**
 * Controlla che tutti gli attibuti passati in listFields sono not-null o, se allNull == true, anche tutti null.
 */
public @interface NotNullDependencies
{
    String message() default "";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    /**
     * Lista di campi da validare, separati da ";".
     */
    String listField();
    
    /**
     * Boolean che specifica se sono ammessi anche tutti valori null.
     */
    boolean allNull();
    
    @Target({TYPE, ANNOTATION_TYPE})
    @Retention(RUNTIME)
    /**
     * Per usare piu'' volte la NotNullDependencies nello stesso Bean.
     */
    @interface List
    {
        NotNullDependencies[] value();
    }
}

