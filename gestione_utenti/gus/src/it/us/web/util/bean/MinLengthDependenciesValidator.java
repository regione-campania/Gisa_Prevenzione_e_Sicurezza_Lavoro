package it.us.web.util.bean;

import org.apache.commons.beanutils.BeanUtils;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;


public class MinLengthDependenciesValidator implements ConstraintValidator<MinLengthDependencies, Object>
{
    private String dependence;
    private String attributo;
    private int minLength;

    
    @Override
    public void initialize(final MinLengthDependencies constraintAnnotation)
    {
    	dependence = constraintAnnotation.dependence();
    	attributo = constraintAnnotation.attributo();
    	minLength = constraintAnnotation.minLength();
    }

    @Override
    public boolean isValid(final Object value, final ConstraintValidatorContext context)
    {
        try
        {
        	
        	Object objDependence = BeanUtils.getProperty(value, dependence);
        	
        	if(objDependence!=null && Boolean.parseBoolean(objDependence.toString())==true)
        	{
        		Object objAttributo = BeanUtils.getProperty(value, attributo);
        		if(objAttributo==null || objAttributo.toString().length()<minLength)
        			return false;
        	}
        	return true;
        	
        }
        catch (final Exception ignore)
        {
            return false;
        }
    }
}